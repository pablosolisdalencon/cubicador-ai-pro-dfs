const express = require('express');
const router = express.Router();
const passport = require('passport');
const PDFDocument = require('pdfkit');
const ExcelJS = require('exceljs');
const Project = require('../../models/Project');
const CubicationItem = require('../../models/CubicationItem');

// @route   POST api/reports/:projectId
// @desc    Generate a report for a project
// @access  Private
router.post(
  '/:projectId',
  passport.authenticate('jwt', { session: false }),
  async (req, res) => {
    try {
      const project = await Project.findById(req.params.projectId);
      if (!project) {
        return res.status(404).json({ projectnotfound: 'No project found' });
      }

      const cubicationItems = await CubicationItem.find({ project: req.params.projectId });
      const { format } = req.body; // 'pdf' or 'excel'

      if (format === 'pdf') {
        const doc = new PDFDocument();
        res.setHeader('Content-Type', 'application/pdf');
        res.setHeader('Content-Disposition', `attachment; filename=${project.name}-report.pdf`);
        doc.pipe(res);

        // PDF Content
        doc.fontSize(25).text(project.name, { align: 'center' });
        doc.fontSize(18).text('Cubicación Report', { align: 'center' });
        doc.moveDown();

        // AI Executive Summary Placeholder
        doc.fontSize(16).text('Executive Summary (AI-Generated)');
        doc.fontSize(12).text('This is a placeholder for the AI-generated summary, highlighting key cost areas and potential budget risks.');
        doc.moveDown();

        cubicationItems.forEach(item => {
          doc.fontSize(14).text(item.description);
          doc.fontSize(10).text(`Unit: ${item.unit} | Dimensions: ${item.dimensions.length}x${item.dimensions.width}x${item.dimensions.height}`);
          doc.moveDown();
        });

        doc.end();
      } else if (format === 'excel') {
        const workbook = new ExcelJS.Workbook();
        const worksheet = workbook.addWorksheet(`${project.name} Report`);

        worksheet.columns = [
          { header: 'Description', key: 'description', width: 50 },
          { header: 'Unit', key: 'unit', width: 10 },
          { header: 'Length', key: 'length', width: 10 },
          { header: 'Width', key: 'width', width: 10 },
          { header: 'Height', key: 'height', width: 10 },
        ];

        cubicationItems.forEach(item => {
          worksheet.addRow({
            description: item.description,
            unit: item.unit,
            length: item.dimensions.length,
            width: item.dimensions.width,
            height: item.dimensions.height,
          });
        });

        res.setHeader('Content-Type', 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet');
        res.setHeader('Content-Disposition', `attachment; filename=${project.name}-report.xlsx`);
        await workbook.xlsx.write(res);
        res.end();
      } else {
        res.status(400).json({ error: 'Invalid report format requested' });
      }
    } catch (err) {
      console.error(err);
      res.status(500).json({ error: 'Server error while generating report' });
    }
  }
);

module.exports = router;
