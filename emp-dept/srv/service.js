const cds = require('@sap/cds')
const { SELECT, UPDATE } = cds.ql

module.exports = class capmService extends cds.ApplicationService {

  async init() {

    const {
      Employees,
      Departments,
      Projects,
      Leaves,
      Payrolls,
      Assets
    } = this.entities

    // =====================================================
    // EMPLOYEE PHOTO URL
    // =====================================================


    this.before('READ', Employees, async req => {

      if (
        req.user.is('Admin') ||
        req.user.is('HRManager')
      ) {
        return
      }

      if (
        req.user.is('Employee') ||
        req.user.is('Viewer')
      ) {

        req.query.where({
          email: req.user.id
        })

      }

    })


    this.after('READ', 'Employees', (employees, req) => {

      const rows = Array.isArray(employees)
        ? employees
        : [employees]

      const isAdmin = req.user.is('Admin')
      const isHR = req.user.is('HRManager')

      rows.forEach(emp => {

        emp.photoUrl =
          emp.photoUrl && emp.photoUrl.trim()
            ? emp.photoUrl
            : `https://ui-avatars.com/api/?name=${encodeURIComponent(emp.name)}&background=CFE8FF&color=0A4ABF&size=128`

        // Bonus Editability
        emp.bonusFieldControl =
          (isAdmin || isHR) ? 7 : 1

        // Employee Actions
        emp.canPromote =
          isAdmin || isHR

        emp.canTransferDepartment =
          isAdmin || isHR

        emp.canAssignManager =
          isAdmin || isHR

        // Entity Operations
        emp.canEditEmployee =
          isAdmin || isHR

        emp.canDeleteEmployee =
          isAdmin

      })

    })




    // =====================================================
    // EMPLOYEE UPDATE AUTHORIZATION
    // =====================================================

    this.before('UPDATE', Employees, async req => {

      // Admin and HR can update everything
      if (
        req.user.is('Admin') ||
        req.user.is('HRManager')
      ) {
        return
      }

      const current = await SELECT.one
        .from(Employees)
        .where({
          ID: req.data.ID || req.params?.[0]?.ID
        })

      if (!current) return

      const protectedFields = [

        'employeeCode',
        'salary',
        'bonus',
        'designation',
        'manager_ID',
        'department_ID',
        'joiningDate'
      ]

      for (const field of protectedFields) {

        if (
          field in req.data &&
          req.data[field] !== current[field]
        ) {

          return req.reject(
            403,
            `${field} cannot be modified`
          )

        }

      }

    })




    // =====================================================
    // EMPLOYEE VALIDATIONS
    // =====================================================

    this.before(['CREATE', 'UPDATE'], Employees, async req => {

      // Age Validation

      if (
        req.data.age !== undefined &&
        req.data.age < 18
      ) {
        req.error('Employee age must be at least 18 years.')
      }

      if (
        req.data.age !== undefined &&
        req.data.age > 65
      ) {
        req.error('Employee age cannot exceed 65 years.')
      }

      // Salary Validation

      if (
        req.data.salary !== undefined &&
        req.data.salary < 0
      ) {
        req.error('Salary cannot be negative.')
      }

      if (
        req.data.bonus !== undefined &&
        req.data.bonus < 0
      ) {
        req.error('Bonus cannot be negative.')
      }

      if (
        req.data.salary !== undefined &&
        req.data.bonus !== undefined &&
        req.data.bonus > req.data.salary
      ) {
        req.error('Bonus cannot exceed salary.')
      }

      // Joining Date

      if (
        req.data.joiningDate &&
        new Date(req.data.joiningDate) > new Date()
      ) {
        req.error('Joining date cannot be in the future.')
      }

      // Manager Validation

      if (
        req.data.manager_ID &&
        req.params?.[0]?.ID &&
        req.data.manager_ID === req.params[0].ID
      ) {
        req.error(
          'Employee cannot be their own manager.'
        )
      }

      // Email Validation

      if (req.data.email) {

        const existingEmail = await SELECT.one
          .from(Employees)
          .where({
            email: req.data.email
          })

        if (
          existingEmail &&
          existingEmail.ID !== req.params?.[0]?.ID
        ) {
          req.error('Email already exists.')
        }
      }

    })

    // =====================================================
    // EMPLOYEE CREATE
    // =====================================================

    this.before('CREATE', Employees, async req => {

      const count = await SELECT.one
        .from(Employees)
        .columns`count(*) as count`

      req.data.employeeCode =
        `EMP${String(Number(count.count) + 1).padStart(4, '0')}`

    })

    // =====================================================
    // DEPARTMENT VALIDATIONS
    // =====================================================

    this.before(
      ['CREATE', 'UPDATE'],
      Departments,
      async req => {

        if (
          req.data.budget !== undefined &&
          req.data.budget < 0
        ) {
          req.error('Budget cannot be negative.')
        }

        if (req.data.name) {

          const department = await SELECT.one
            .from(Departments)
            .where({
              name: req.data.name
            })

          if (
            department &&
            department.ID !== req.params?.[0]?.ID
          ) {
            req.error('Department already exists.')
          }
        }

      }
    )

    // =====================================================
    // PROJECT VALIDATIONS
    // =====================================================

    this.before(
      ['CREATE', 'UPDATE'],
      Projects,
      req => {

        if (
          req.data.validFrom &&
          req.data.validTo &&
          new Date(req.data.validTo) <
          new Date(req.data.validFrom)
        ) {
          req.error(
            'Project end date must be after start date.'
          )
        }

        if (
          req.data.cost !== undefined &&
          req.data.budget !== undefined &&
          req.data.cost > req.data.budget
        ) {
          req.error(
            'Project cost cannot exceed project budget.'
          )
        }

      }
    )

    // =====================================================
    // LEAVE VALIDATIONS
    // =====================================================

    this.before(
      ['CREATE', 'UPDATE'],
      Leaves,
      req => {

        if (
          req.data.startDate &&
          req.data.endDate &&
          new Date(req.data.endDate) <
          new Date(req.data.startDate)
        ) {
          req.error(
            'Leave end date must be after start date.'
          )
        }

        if (
          req.data.totalDays !== undefined &&
          req.data.totalDays <= 0
        ) {
          req.error(
            'Leave days must be greater than zero.'
          )
        }

      }
    )

    // =====================================================
    // ASSET VALIDATIONS
    // =====================================================

    this.before(
      ['CREATE', 'UPDATE'],
      Assets,
      req => {

        if (
          req.data.purchaseDate &&
          req.data.warrantyEndDate &&
          new Date(req.data.warrantyEndDate) <
          new Date(req.data.purchaseDate)
        ) {
          req.error(
            'Warranty end date cannot be before purchase date.'
          )
        }

        if (
          req.data.purchaseCost !== undefined &&
          req.data.purchaseCost <= 0
        ) {
          req.error(
            'Purchase cost must be greater than zero.'
          )
        }

      }
    )

    // =====================================================
    // CRITICALITY
    // =====================================================

    this.after('READ', 'Employees', employees => {

      const rows = Array.isArray(employees)
        ? employees
        : [employees]

      rows.forEach(e => {

        switch (e.designation) {

          case 'DIRECTOR':
            e.designationCriticality = 3
            break

          case 'MANAGER':
            e.designationCriticality = 3
            break

          case 'LEAD':
            e.designationCriticality = 5
            break

          case 'SENIOR_ENG':
            e.designationCriticality = 2
            break

          case 'ENGINEER':
            e.designationCriticality = 1
            break

          case 'INTERN':
            e.designationCriticality = 1
            break
        }

      })

    })



    // =====================================================
    // EMPLOYEE BOUND FUNCTIONS
    // =====================================================

    this.on('getAnnualSalary', Employees, async req => {

      const emp = await SELECT.one
        .from(Employees)
        .where({ ID: req.params[0].ID })

      return ((emp.salary || 0) + (emp.bonus || 0)) * 12
    })

    this.on('getTeamSize', Employees, async req => {

      const result = await SELECT.one
        .from(Employees)
        .columns`count(*) as count`
        .where({
          manager_ID: req.params[0].ID
        })

      return result.count
    })

    this.on('getManager', Employees, async req => {

      const employee = await SELECT.one
        .from(Employees)
        .columns('manager_ID')
        .where({
          ID: req.params[0].ID
        })

      if (!employee?.manager_ID) {
        return null
      }

      return await SELECT.one
        .from(Employees)
        .where({
          ID: employee.manager_ID
        })
    })

    this.on('getSalaryBreakup', Employees, async req => {

      const employee = await SELECT.one
        .from(Employees)
        .where({
          ID: req.params[0].ID
        })

      return {
        basic: employee.salary || 0,
        bonus: employee.bonus || 0,
        totalSalary:
          (employee.salary || 0) +
          (employee.bonus || 0)
      }
    })

    // =====================================================
    // EMPLOYEE BOUND ACTIONS
    // =====================================================



    this.before('*', req => {
      console.log('User:', req.user.id)
      console.log('Roles:', req.user.roles)
    })


    this.on('promote', Employees, async req => {

      if (!(req.user.is('Admin') || req.user.is('HRManager')))
        return req.reject(403, 'Not authorized')

      await UPDATE(Employees)
        .set({
          designation: req.data.newDesignation
        })
        .where({
          ID: req.params[0].ID
        })

      return 'Employee promoted successfully'
    })



    this.on('transferDepartment', Employees, async req => {

      if (!(req.user.is('Admin') || req.user.is('HRManager')))
        return req.reject(403, 'Not authorized')

      await UPDATE(Employees)
        .set({
          department_ID: req.data.departmentId
        })
        .where({
          ID: req.params[0].ID
        })

      return 'Department transferred successfully'
    })

    this.on('assignManager', Employees, async req => {

      if (!(req.user.is('Admin') || req.user.is('HRManager')))
        return req.reject(403, 'Not authorized')

      await UPDATE(Employees)
        .set({
          manager_ID: req.data.managerId
        })
        .where({
          ID: req.params[0].ID
        })

      return 'Manager assigned successfully'
    })

    // =====================================================
    // DEPARTMENT FUNCTIONS & ACTIONS
    // =====================================================

    this.on('getEmployeeCount', Departments, async req => {

      const result = await SELECT.one
        .from(Employees)
        .columns`count(*) as count`
        .where({
          department_ID: req.params[0].ID
        })

      return result.count
    })

    this.on('allocateBudget', Departments, async req => {

      const department = await SELECT.one
        .from(Departments)
        .where({
          ID: req.params[0].ID
        })

      await UPDATE(Departments)
        .set({
          budget:
            (department.budget || 0) +
            req.data.amount
        })
        .where({
          ID: req.params[0].ID
        })

      return 'Budget allocated successfully'
    })

    // =====================================================
    // PROJECT FUNCTIONS & ACTIONS
    // =====================================================

    this.on('getProjectCost', Projects, async req => {

      const project = await SELECT.one
        .from(Projects)
        .where({
          ID: req.params[0].ID
        })

      return project.cost || 0
    })

    this.on('changeManager', Projects, async req => {

      await UPDATE(Projects)
        .set({
          projectManager_ID: req.data.managerId
        })
        .where({
          ID: req.params[0].ID
        })

      return 'Project manager changed successfully'
    })

    // =====================================================
    // UNBOUND FUNCTIONS
    // =====================================================

    this.on('getEmployeeCount', async () => {

      const result = await SELECT.one
        .from(Employees)
        .columns`count(*) as count`

      return result.count
    })

    this.on('getDepartmentCount', async () => {

      const result = await SELECT.one
        .from(Departments)
        .columns`count(*) as count`

      return result.count
    })

    this.on('getActiveProjectCount', async () => {

      const result = await SELECT.one
        .from(Projects)
        .columns`count(*) as count`
        .where({
          status: 'ACTIVE'
        })

      return result.count
    })

    this.on('getTotalPayrollCost', async () => {

      const result = await SELECT.one
        .from(Payrolls)
        .columns`sum(netSalary) as total`

      return result.total || 0
    })

    this.on('getDashboardSummary', async () => {

      const employees =
        await SELECT.one
          .from(Employees)
          .columns`count(*) as count`

      const departments =
        await SELECT.one
          .from(Departments)
          .columns`count(*) as count`

      const projects =
        await SELECT.one
          .from(Projects)
          .columns`count(*) as count`

      return {
        employeeCount: employees.count,
        departmentCount: departments.count,
        projectCount: projects.count
      }
    })

    this.on('getTopEmployees', async () => {

      return await SELECT
        .from(Employees)
        .orderBy('salary desc')
        .limit(5)
    })

    this.on('getProjectsByDepartment', async req => {

      return await SELECT
        .from(Projects)
        .where({
          department_ID: req.data.departmentId
        })
    })

    // =====================================================
    // UNBOUND ACTIONS
    // =====================================================

    this.on('generateMonthlyPayroll', async req => {

      console.log(
        `Generating payroll for ${req.data.month}-${req.data.year}`
      )

      return 'Payroll generated successfully'
    })

    this.on('closeProject', async req => {

      await UPDATE(Projects)
        .set({
          status: 'COMPLETED'
        })
        .where({
          ID: req.data.projectId
        })

      return 'Project closed successfully'
    })


    this.on('approveLeave', Leaves, async req => {

      if (
        !req.user.is('Admin') &&
        !req.user.is('HRManager') &&
        !req.user.is('DepartmentManager')
      ) {
        return req.reject(403, 'Not authorized')
      }

      const leave = await SELECT.one
        .from(Leaves)
        .where({
          ID: req.params[0].ID
        })

      if (leave.status !== 'PENDING') {
        return req.reject(
          400,
          'Only pending leave can be approved'
        )
      }

      await UPDATE(Leaves)
        .set({
          status: 'APPROVED'
        })
        .where({
          ID: req.params[0].ID
        })


      await INSERT.into('leave.db.LeaveApprovals')
        .entries({
          leave_ID: req.params[0].ID,
          action: 'APPROVED',
          remarks: req.data.remarks,
          actionDate: new Date()
        })


      return 'Leave approved successfully'
    })



    this.on('rejectLeave', Leaves, async req => {

      if (
        !req.user.is('Admin') &&
        !req.user.is('HRManager') &&
        !req.user.is('DepartmentManager')
      ) {
        return req.reject(403, 'Not authorized')
      }


      await INSERT.into('leave.db.LeaveApprovals')
        .entries({
          leave_ID: req.params[0].ID,
          action: 'REJECTED',
          remarks: req.data.remarks,
          actionDate: new Date()
        })



      await UPDATE(Leaves)
        .set({
          status: 'REJECTED'
        })
        .where({
          ID: req.params[0].ID
        })

      return 'Leave rejected successfully'
    })





    this.on('cancelLeave', Leaves, async req => {

      await UPDATE(Leaves)
        .set({
          status: 'CANCELLED'
        })
        .where({
          ID: req.params[0].ID
        })

      return 'Leave cancelled successfully'
    })



    this.on('assignAsset', async req => {

      await UPDATE(Assets)
        .set({
          assignedTo_ID: req.data.employeeId
        })
        .where({
          ID: req.data.assetId
        })



      return 'Asset assigned successfully'
    })

    return super.init()
  }

}